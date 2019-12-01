<?php

namespace Akuma\Bundle\PahoniaBundle\Extension;

use Oro\Component\MessageQueue\Consumption\AbstractExtension;
use Oro\Component\MessageQueue\Consumption\Context;
use Oro\Component\MessageQueue\Consumption\MessageProcessorInterface;

class RejectRedeliveredMessageExtension extends AbstractExtension
{
    const PROPERTY_REDELIVER_COUNT = 'oro-redeliver-count';

    /**
     * {@inheritdoc}
     */
    public function onPreReceived(Context $context)
    {
        $message = $context->getMessage();
        $properties = $message->getProperties();
        if (isset($properties[self::PROPERTY_REDELIVER_COUNT]) && $properties[self::PROPERTY_REDELIVER_COUNT] > 3) {
            $context->setStatus(MessageProcessorInterface::REJECT);
            $context->getLogger()->error('Max count of REDELIVER.');

            return;
        }
    }
}
